require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  context 'Global settings' do
    it { expect(Ability).to include(CanCan::Ability)                       }
    it { expect(Ability).to respond_to(:new).with(1).argument              }
    it { expect(Abilities::Admin).to include(CanCan::Ability)              }
    it { expect(Abilities::Admin).to respond_to(:new).with(1).argument     }
    it { expect(Abilities::Publisher).to include(CanCan::Ability)          }
    it { expect(Abilities::Publisher).to respond_to(:new).with(1).argument }
    it { expect(Abilities::Editor).to include(CanCan::Ability)             }
    it { expect(Abilities::Editor).to respond_to(:new).with(1).argument    }
    it { expect(Abilities::User).to include(CanCan::Ability)               }
    it { expect(Abilities::User).to respond_to(:new).with(1).argument      }
    it { expect(Abilities::Guest).to include(CanCan::Ability)              }
    it { expect(Abilities::Guest).to respond_to(:new).with(1).argument     }
  end

  context 'admin' do
    before :each do
      @admin = create(:admin)
    end

    it 'can manage objects' do
      expect_any_instance_of(Abilities::Admin).to receive(:can).with(:manage, :all)

      expect_any_instance_of(Abilities::Admin).to receive(:cannot).with(:destroy, ::User, id: @admin.id)
      expect_any_instance_of(Abilities::Admin).to receive(:cannot).with([:activate, :deactivate], ::User, id: @admin.id)
      Abilities::Admin.new @admin
    end
  end

  context 'publisher' do
    before :each do
      @publisher = create(:publisher)
    end

    it 'can manage objects' do
      expect_any_instance_of(Abilities::Publisher).to receive(:can).with(:read, :all)
      expect_any_instance_of(Abilities::Publisher).to receive(:can).with(:manage, ::Project, project_users: { user_id: @publisher.id, is_owner: true })
      expect_any_instance_of(Abilities::Publisher).to receive(:can).with(:update, ::User, id: @publisher.id)
      expect_any_instance_of(Abilities::Publisher).to receive(:can).with(:update, ::Project, project_users: { user_id: @publisher.id })
      expect_any_instance_of(Abilities::Publisher).to receive(:can).with([:publish, :unpublish], ::Project)
      [::Comment, ::Project, ::User, ::Photo, ::Document, ::ExternalSource, ::Country, ::Impact].each do |model|
        expect_any_instance_of(Abilities::Publisher).to receive(:can).with([:activate, :deactivate], model)
      end
      expect_any_instance_of(Abilities::Publisher).to receive(:cannot).with([:activate, :deactivate], ::User, id: @publisher.id)
      Abilities::Publisher.new @publisher
    end
  end

  context 'editor' do
    before :each do
      @editor = create(:editor)
    end

    it 'can manage objects' do
      expect_any_instance_of(Abilities::Editor).to receive(:can).with(:manage, ::Project, project_users: { user_id: @editor.id, is_owner: true })
      expect_any_instance_of(Abilities::Editor).to receive(:can).with(:update, ::User, id: @editor.id)
      expect_any_instance_of(Abilities::Editor).to receive(:can).with(:update, ::Project, project_users: { user_id: @editor.id })
      Abilities::Editor.new @editor
    end
  end

  context 'user' do
    before :each do
      @user = create(:user)
    end

    it 'can manage objects' do
      expect_any_instance_of(Abilities::User).to receive(:can).with(:update, ::User, id: @user.id)
      expect_any_instance_of(Abilities::User).to receive(:can).with(:update, ::Project, project_users: { user_id: @user.id })
      Abilities::User.new @user
    end
  end

  context 'guest' do
    before :each do
      @user = create(:user)
    end

    it 'can manage objects' do
      expect_any_instance_of(Abilities::Guest).to receive(:can).with(:update, ::User, id: @user.id)
      Abilities::Guest.new @user
    end
  end
end
