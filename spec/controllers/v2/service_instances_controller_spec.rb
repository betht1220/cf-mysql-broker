require 'spec_helper'

describe V2::ServiceInstancesController do
  let(:db_settings) { Rails.configuration.database_configuration[Rails.env] }
  let(:admin_user) { db_settings.fetch('username') }
  let(:admin_password) { db_settings.fetch('password') }
  let(:database_host) { db_settings.fetch('host') }
  let(:database_port) { db_settings.fetch('port') }

  before do
    authenticate
  end

  describe '#update' do
    let(:instance_id) { 'INSTANCE-1' }
    let(:dbname) { DatabaseName.new(instance_id) }

    before do

      ActiveRecord::Base.connection.
          should_receive(:execute).
          with("CREATE DATABASE #{dbname.name};")
    end

    it 'sends back a dashboard url' do
      put :update, id: instance_id

      expect(response.status).to eq(201)
      instance = JSON.parse(response.body)

      expect(instance['dashboard_url']).to eq('http://fake.dashboard.url')
    end
  end

  describe '#destroy' do
    let(:instance_id) { 'INSTANCE-1' }
    let(:dbname) { DatabaseName.new(instance_id) }

    before do
      ActiveRecord::Base.connection.
          should_receive(:execute).
          with("DROP DATABASE #{dbname.name};")
    end

    it 'succeeds with 204' do
      delete :destroy, id: instance_id

      expect(response.status).to eq(204)
    end
  end
end
