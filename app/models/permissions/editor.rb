# frozen_string_literal: true
module Permissions
  class Editor
    class << self
      def abilities
        {
          'all': {
            'StudyCase':      ['create', 'read'],
            'BusinessModel':  ['create'],
            'Bme':            ['read'],
            'Category':       ['read'],
            'City':           ['read'],
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
            'User':           ['update'],
            'StudyCase':      ['delete'],
            'BusinessModel':  ['delete']
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
