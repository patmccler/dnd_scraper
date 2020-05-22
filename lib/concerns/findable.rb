# common functionality for finding things by name, ect

module Findable
  # assume class has class.all method available
  module ClassMethods
    def find_by_name(name)
      all.find { |o| o.name.casecmp(name).zero? }
    end

    # find object in Counting numbered list
    def find_by_number(num)
      all[num.to_i - 1] if (1..count).cover?(num.to_i)
    end

    # takes a string and attempts to find by either name or number
    def find_by_name_or_number(input)
      find_by_name(input) || find_by_number(input)
    end

    def find_by_name_from_list(collection, name)
      collection.find { |elem| elem.name.casecmp(name).zero? }
    end
  end
end
