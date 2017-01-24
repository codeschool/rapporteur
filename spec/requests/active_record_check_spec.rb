require 'spec_helper'

describe 'A status request with an ActiveRecordCheck', :type => :request do
  before do
    Rapporteur.add_check(Rapporteur::Checks::ActiveRecordCheck)
  end

  subject { get(status_path) ; response }

  context 'with an unerring ActiveRecord connection' do
    it_behaves_like 'a successful status response'
  end

  context 'with a failed ActiveRecord connection' do
    before do
      allow(ActiveRecord::Base.connection).to receive(:select_value).
        and_raise(ActiveRecord::ConnectionNotEstablished)
    end

    it_behaves_like 'an erred status response'

    it 'contains a message regarding the database failure' do
      expect(subject).to include_status_error_message(:database, I18n.t('rapporteur.errors.database.unavailable'))
    end
  end
end
