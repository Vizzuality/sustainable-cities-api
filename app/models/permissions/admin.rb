# frozen_string_literal: true
module Permissions
  class Admin
    class << self
      def abilities
        {
          'all': {
            'StudyCase':      ['create', 'update', 'destroy', 'read', 'activate', 'deactivate', 'publish', 'unpublish'],
            'BusinessModel':  ['create', 'update', 'destroy', 'read', 'activate', 'deactivate', 'publish', 'unpublish'],
            'Bme':            ['create', 'update', 'destroy', 'read'],
            'Category':       ['create', 'update', 'destroy', 'read'],
            'City':           ['create', 'update', 'destroy', 'read'],
            'Event':          ['create', 'update', 'destroy', 'read'],
            'Blog':           ['create', 'update', 'destroy', 'read'],
            'CitySupport':    ['create', 'update', 'destroy', 'read'],
            'Comment':        ['create', 'destroy', 'activate', 'deactivate'],
            'Country':        ['create', 'update', 'destroy', 'read', 'activate', 'deactivate'],
            'Document':       ['create', 'update', 'destroy', 'read', 'activate', 'deactivate'],
            'Enabling':       ['create', 'update', 'destroy', 'read'],
            'ExternalSource': ['create', 'update', 'destroy', 'read', 'activate', 'deactivate'],
            'Impact':         ['create', 'update', 'destroy', 'read', 'activate', 'deactivate'],
            'Photo':          ['create', 'update', 'destroy', 'read', 'activate', 'deactivate'],
            'User':           ['create', 'update', 'destroy', 'read', 'activate', 'deactivate']
          },
          'owner': {},
          'member': {}
        }
      end
    end
  end
end
