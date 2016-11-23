require "spec_helper"

describe CorreiosSlackBot::Correios do
  let(:correios) { CorreiosSlackBot::Correios.new('DU841641734BR') }

  describe '#package_log' do
    it 'Return the package log' do
      VCR.use_cassette('package_log') do
        expect(correios.package_log).to include(
            {
              date: '18/11/2016 15:04',
              origin: 'CEE BANGU - Rio De Janeiro/RJ',
              status: 'Encaminhado',
              description: 'Em trânsito para CDD DEODORO - Rio De Janeiro/RJ'
            }
        )
      end
    end
  end
end
