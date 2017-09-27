# frozen_string_literal: true
module Permissions
  class User
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
            'Comment':        ['create'],
            'Country':        ['read'],
            'Document':       ['read'],
            'Enabling':       ['read'],
            'ExternalSource': ['read'],
            'Impact':         ['read'],
            'Photo':          ['read'],
            'User':           ['read']
          },
          'owner': {
            'User':           ['update']
          },
          'member': {
            'StudyCase':      ['update'],
            'BusinessModel':  ['read', 'update']
          }
        }
      end
    end
  end
end
