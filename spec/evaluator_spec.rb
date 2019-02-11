require 'spec_helper'

describe BooleanDsl::Evaluator do
  context '#evaluate_comparison' do
    let(:evaluator) { described_class.new(nil, nil) }

    specify { expect(evaluator.evaluate_comparison(1, '==', 1)).to be_truthy }
    specify { expect(evaluator.evaluate_comparison(1, '==', 0)).to be_falsey }
    specify { expect(evaluator.evaluate_comparison(1, '!=', 1)).to be_falsey }
    specify { expect(evaluator.evaluate_comparison(1, '!=', 0)).to be_truthy }

    specify { expect(evaluator.evaluate_comparison('alpha', '==', 'alpha')).to be_truthy }
    specify { expect(evaluator.evaluate_comparison('beta', '==', 'omega')).to be_falsey }
    specify { expect(evaluator.evaluate_comparison('alpha', '!=', 'alpha')).to be_falsey }
    specify { expect(evaluator.evaluate_comparison('beta', '!=', 'omega')).to be_truthy }

    specify { expect(evaluator.evaluate_comparison(10, '<', 20)).to be_truthy }
    specify { expect(evaluator.evaluate_comparison(20, '<', 10)).to be_falsey }
    specify { expect(evaluator.evaluate_comparison(20, '>', 10)).to be_truthy }
    specify { expect(evaluator.evaluate_comparison(10, '>', 20)).to be_falsey }
    specify { expect(evaluator.evaluate_comparison(20, '<=', 20)).to be_truthy }
    specify { expect(evaluator.evaluate_comparison(20, '>=', 20)).to be_truthy }
  end

  context '#evaluate_boolean' do
    let(:evaluator) { described_class.new(nil, nil) }

    before do
      allow(evaluator).to receive(:evaluate).with(true).and_return(true)
      allow(evaluator).to receive(:evaluate).with(false).and_return(false)
    end

    specify { expect(evaluator.evaluate_boolean(true, 'and', true)).to be_truthy }
    specify { expect(evaluator.evaluate_boolean(true, 'and', false)).to be_falsey }
    specify { expect(evaluator.evaluate_boolean(false, 'and', true)).to be_falsey }
    specify { expect(evaluator.evaluate_boolean(false, 'and', false)).to be_falsey }

    specify { expect(evaluator.evaluate_boolean(true, 'or', true)).to be_truthy }
    specify { expect(evaluator.evaluate_boolean(true, 'or', false)).to be_truthy }
    specify { expect(evaluator.evaluate_boolean(false, 'or', true)).to be_truthy }
    specify { expect(evaluator.evaluate_boolean(false, 'or', false)).to be_falsey }
  end

  context 'full parse' do
    def outcome_for(expression, context_hash = {})
      described_class.new(expression, context_hash).outcome
    end
    specify { expect(outcome_for('1 == 1')).to be_truthy }
    specify { expect(outcome_for('1 == 0')).to be_falsey }
    specify { expect(outcome_for("(1 < 4 or 5 < 4) and (1 == 1 and 'alpha' == 'alpha')")).to be_truthy }
    specify { expect(outcome_for('gamma == 7', { 'gamma' => 7 })).to be_truthy }
    specify { expect(outcome_for('gamma == 8', { 'gamma' => 7 })).to be_falsey }
    specify { expect(outcome_for("alpha == 'beta'", { 'alpha' => 'beta' })).to be_truthy }
    specify { expect(outcome_for("alpha == 'beta'", { 'alpha' => 'delta' })).to be_falsey }
  end
end

