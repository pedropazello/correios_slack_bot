require "spec_helper"

describe CorreiosSlackBot::CorreiosMonitor do
  before do
    VCR.insert_cassette('package_log')
  end

  after do
    VCR.eject_cassette
  end

  let(:package_log) do
    [
      {
        date: '16/11/2016 16:05',
        origin: 'AGF JARDIM UNIVERSO - Mogi Das Cruzes/SP',
        status: 'Postado',
        description: 'Em trânsito para CTE VILA MARIA - Sao Paulo/SP'
      }
    ]
  end

  let(:correios_monitor) do
    CorreiosSlackBot::CorreiosMonitor.new("DU841641734BR", {
      from_package_log: package_log
    })
  end

  context 'when package log changes' do
    describe '#package_log_changed?' do
      it { expect(correios_monitor.package_log_changed?).to be_truthy }
    end

    describe '#last_change' do
      it do
        expect(correios_monitor.last_change).to eq(
          {
            date: '18/11/2016 15:04',
            origin: 'CEE BANGU - Rio De Janeiro/RJ',
            status: 'Encaminhado',
            description: 'Em trânsito para CDD DEODORO - Rio De Janeiro/RJ'
          }
        )
      end
    end

    describe '#monitor' do
      it do
        changed = Proc.new { 'changed'  }
        not_changed = Proc.new { 'not changed' }
        expect(correios_monitor.monitor(when_change: changed,
          when_not_change: not_changed)).to eq('changed')
      end
    end
  end

  context 'when package log not changes' do
    before do
      allow(correios_monitor).to receive(:package_log_changed?) { false }
    end

    describe '#package_log_changed?' do
      it { expect(correios_monitor.package_log_changed?).to be_falsey }
    end

    describe '#last_change' do
      it do
        expect(correios_monitor.last_change).to eq(
          {
            date: '18/11/2016 15:04',
            origin: 'CEE BANGU - Rio De Janeiro/RJ',
            status: 'Encaminhado',
            description: 'Em trânsito para CDD DEODORO - Rio De Janeiro/RJ'
          }
        )
      end
    end

    describe '#monitor' do
      it do
        changed = Proc.new { 'changed'  }
        not_changed = Proc.new { 'not changed' }
        expect(correios_monitor.monitor(when_change: changed,
          when_not_change: not_changed)).to eq('not changed')
      end
    end
  end
end
