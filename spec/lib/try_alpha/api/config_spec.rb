require 'spec_helper'

RSpec.describe TryAlpha::API::Config do
  describe '.load' do
    subject(:load_config) { described_class.load }

    context 'when the config file exists' do
      let(:config_file_hash) do
        { token: 'abc123', organization_slug: 'test' }
      end

      before do
        allow(YAML).to receive(:load_file).and_return(config_file_hash)
      end

      it { is_expected.to be_a(described_class) }
      it { expect(load_config.token).to eq('abc123') }
      it { expect(load_config.organization_slug).to eq('test') }
    end

    context 'when the config file does not exist' do
      before do
        allow(YAML).to receive(:load_file).and_raise(Errno::ENOENT)
      end

      it { is_expected.to be_a(described_class) }
      it { expect(load_config.token).to be_nil }
      it { expect(load_config.organization_slug).to be_nil }
    end
  end
end
