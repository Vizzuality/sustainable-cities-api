# frozen_string_literal: true
module SortParams
  def self.sorted_fields(sort, allowed, default)
    allowed = allowed.map(&:to_s)
    fields  = sort.to_s.split(',')

    ordered_fields  = convert_to_ordered_hash(fields)
    filtered_fields = ordered_fields.select { |key, value| allowed.include?(key) }
    filtered_fields.present? ? filtered_fields : default

    if filtered_fields.present?
      if filtered_fields.keys.first.include?('.')
        filtered_fields.to_a.flatten.join(' ')
      else
        filtered_fields
      end
    else
      default
    end
  end

  def self.convert_to_ordered_hash(fields)
    fields.each_with_object({}) do |field, hash|
      if field.start_with?('-')
        field = field[1..-1]
        hash[field] = :desc
      else
        hash[field] = :asc
      end
    end
  end
end
