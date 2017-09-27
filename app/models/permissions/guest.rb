# frozen_string_literal: true
module Permissions
  class Guest
    class << self
      def abilities
        {
          'all': {
            'StudyCase':      ['read'],
            'BusinessModel':  [],
            'Bme':            ['read'],
            'Category':       ['read'],
            'City':           ['read'],
            'Event':          ['read'],
            'Blog':           ['read'],
            'CitySupport':    ['read'],
            'Comment':        [],
            'Country':        ['read'],
            'Document':       ['read'],
            'Enabling':       ['read'],
            'ExternalSource': ['read'],
            'Impact':         ['read'],
            'Photo':          ['read'],
            'User':           ['read']
          },
          'owner': {},
          'member': {}
        }
      end
    end
  end
end
