require 'spec_helper'

RSpec.describe TryAlpha::RailsTemplateRunner do
  describe '#run' do
    subject(:run) { template_runner.run }

    let(:template_runner) { described_class.new(location) }
    let(:location) { 'path/to/template' }

    before do
      allow(template_runner).to receive(:system).and_return(true)
    end

    it { expect(run).to be_truthy }
  end
end
