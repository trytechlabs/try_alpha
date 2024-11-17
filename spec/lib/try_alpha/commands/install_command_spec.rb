require 'spec_helper'

RSpec.describe TryAlpha::Commands::InstallCommand do
  describe '#run' do
    subject(:install) { described_class.new(template_name, options:).run }

    context 'when the template name is not provided' do
      let(:template_name) { nil }
      let(:options) { {} }

      it do
        expect { install }.to \
          raise_error(TryAlpha::MissingArgumentError, 'You must provide a template name')
      end
    end

    context 'when the template name is provided' do
      context 'and the credentials are invalid' do
        let(:template_name) { 'rspec' }
        let(:options) { {} }

        before { stub_api_client! }

        it { expect { install }.to output(/You need to login/).to_stdout }
      end

      context 'and the credentials are valid' do
        context 'and the template is not found' do
          let(:template_name) { 'missing' }
          let(:options) { {} }

          before { stub_api_client!(:with_valid_credentials) }

          it { expect { install }.to raise_error(TryAlpha::TemplateNotFoundError, /missing/) }
        end

        context 'and the template is found but invalid' do
          let(:template_name) { 'foo' }
          let(:options) { { yes: true } }

          before do
            stub_api_client!(:with_valid_credentials, :with_found_invalid_template)
          end

          around do |example|
            original_stdout = $stdout
            $stdout = StringIO.new
            example.run
            $stdout = original_stdout
          end

          it { expect { install }.to raise_error(TryAlpha::InstallTemplateError, /foo/) }
        end

        context 'and the template is found and valid' do
          let(:template_name) { 'rspec' }
          let(:options) { { yes: true } }

          before do
            stub_api_client!(:with_valid_credentials, :with_found_template)
          end

          it { expect { install }.to output(/Installing rspec/).to_stdout }
          it { expect { install }.to output(/Rails templating command stub/).to_stdout }
          it { expect { install }.to output(/Template rspec installed successfully!/).to_stdout }
        end
      end
    end
  end
end
