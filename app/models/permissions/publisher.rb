# frozen_string_literal: true
module Permissions
  class Publisher
    class << self
      def abilities
        {
          'all': {
            'StudyCase':      ['create', 'read', 'activate', 'deactivate', 'publish', 'unpublish'],
            'BusinessModel':  ['create', 'read', 'activate', 'deactivate', 'publish', 'unpublish'],
            'Bme':            ['read'],
            'Category':       ['read'],
            'City':           ['read'],
            'Event':          ['read'],
            'Blog':           ['read'],
            'CitySupport':    ['read'],
            'Comment':        ['create', 'activate', 'deactivate'],
            'Country':        ['read', 'activate', 'deactivate'],
            'Document':       ['read', 'activate', 'deactivate'],
            'Enabling':       ['read'],
            'ExternalSource': ['read', 'activate', 'deactivate'],
            'Impact':         ['read', 'activate', 'deactivate'],
            'Photo':          ['read', 'activate', 'deactivate'],
            'User':           ['read', 'activate', 'deactivate']
          },
          'owner': {
            'User':           ['update'],
            'StudyCase':      ['delete'],
            'BusinessModel':  ['delete']
          },
          'member': {
            'StudyCase':      ['update'],
            'BusinessModel':  ['update']
          }
        }
      end
    end
  end
end
