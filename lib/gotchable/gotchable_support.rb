module Gotchable
  class GotchableSupport
    attr_reader :relation
    attr_accessor :default_payload

    def initialize(relation)
      @relation = relation
      @table_name = relation.table_name
    end

    def joins(join_tables)
      @relation = @relation.joins(join_tables)
      self
    end

    def likes(columns, payload = {}, option = {})
      payload = default_payload unless payload.present?
      fuzzy = option.dig(:fuzzy)
      columns.each do |col|
        value = payload.dig(path_to_vaild_key(path: col.to_s).to_sym)
        @relation = @relation.where("#{col} LIKE ?", get_fuzzy_query_value(fuzzy, value)) unless value.nil?
      end
      self
    end

    def equals(columns, payload = {})
      payload = default_payload unless payload.present?
      columns.each do |col|
        value = real_boolean! payload.dig(path_to_vaild_key(path: col.to_s).to_sym)
        @relation = @relation.where(path_to_nested_hash(path: col.to_s, value: value)) unless value.nil?
      end
      self
    end

    def fuzzy(columns, value = "")
      value ||= default_payload[:query]
      if value.present?
        @relation = process_fuzzy_query(columns, value)
      end
      self
    end

    def between_time_scope(columns, payload = {})
      payload = default_payload unless payload.present?
      columns.each do |col|
        values = payload[col]
        @relation = process_between_times(col, values)
      end

      self
    end

    def between_value_scope(columns, payload = {})
      payload = default_payload unless payload.present?
      columns.each do |col|
        values = payload[col]
        @relation = process_between_values(col, values)
      end

      self
    end

    def between_scope(columns, payload = {}, type = nil)
      payload = default_payload unless payload.present?
      columns.each do |col|
        values = payload[col]
        @relation.columns_hash[col].type
        judge_type = type&.to_sym || @relation.columns_hash[col.to_s].type
        @relation = case judge_type
                    when :datetime
                      process_between_times(col, values)
                    else
                      process_between_values(col, values)
                    end
      end

      self
    end

    private

    def process_between_times(column, values)
      return @relation if values.blank?
      time_range = Time.parse(values[0]).beginning_of_day..Time.parse(values[1]).at_end_of_day
      @relation.where(column => time_range)
    end

    def process_between_values(column, values)
      return @relation if values.blank?
      value_range = values[0]..values[1]
      @relation.where(column => value_range)
    end

    def process_fuzzy_query(query_columns, query)
      query_str = query_columns.map do |column|
        column = column.to_s
        real_column = column.index(".") ? column.split(".").map { |col| "`#{col}`" }.join(".") : "`#{@table_name}`.`#{column}`"
        "#{real_column} LIKE :query"
      end.join(" OR ")

      @relation.where(query_str, query: "%#{query}%")
    end

    def nested_to_flat_hash(payload:, current_key: "", result: {}, spliter: "_")
      return result.update(current_key => payload) unless payload.is_a? Hash
      payload.each do |k, r|
        nested_to_flat_hash(payload: r, current_key: (current_key.present? ? "#{current_key}#{spliter}#{k}" : k), result: result, spliter: spliter)
      end
      result
    end

    def flat_to_nested_hash(payload:, spliter: "_")
      payload.each_with_object({}) do |(current_keys, object), f|
        current_keys_arr = current_keys.split(spliter)
        current_key = current_keys_arr.first
        current_obejct = current_keys_arr.size == 1 ? object : flat_to_nested_hash(payload: { current_keys_arr[1..-1].join(spliter) => object }, spliter: spliter)
        f.update(current_key => current_obejct) do |_, acc, cur|
          acc.merge(cur)
        end
      end
    end

    def path_to_nested_hash(path:, value:, spliter: ".", result: {})
      spliter_postion = path.index(spliter)
      return { path => value } if spliter_postion.nil?
      rest_path = path.slice((spliter_postion + 1)..-1)
      cur_path = path.slice(0, spliter_postion)
      result = result.merge(cur_path => path_to_nested_hash(path: rest_path, value: value, spliter: spliter, result: result))
      result
    end

    def path_to_vaild_key(path:, before_spliter: ".", after_spliter: "_")
      tmp_arr = path.split(before_spliter)
      return path if tmp_arr.size.zero?
      tmp_arr[0] = tmp_arr[0].singularize
      tmp_arr.join(after_spliter)
    end

    def get_fuzzy_query_value(fuzzy, value)
      if fuzzy == "right"
        "#{value}%"
      elsif fuzzy == "left"
        "%#{value}"
      else
        "%#{value}%"
      end
    end

    def real_boolean!(value)
      return 1 if value == "true"
      return 0 if value == "false"
      value
    end
  end
end
