# Encapsulates the @all functionality

module Memoable
  module InstanceMethods
    def save
      tap { |me| self.class.all << me }
    end
  end

  module ClassMethods
    # lets the class define a generate_all method
    # defaults to empty array if none given
    def all
      @all ||= []
    end

    # allow classes implementing memoable to detect first call of all
    def all_nil?
      @all.nil?
    end

    def count
      all.size
    end
  end
end
