require 'spec_helper'

describe 'BooleanDsl::Evaluator#evaluate with context' do
  let(:context) do
    {
      'alpha' => 'omega',
      'gamma' => 7,
      'delta' => true,
      'yotta' => false,
      'theta' => [1,2,3],
    }
  end

  let(:evaluator) { BooleanDsl::Evaluator.new(nil, context) }

  context 'attribute' do
    specify { expect(evaluator.evaluate(attribute: 'alpha')).to eq('omega') }
    specify { expect(evaluator.evaluate(attribute: 'gamma')).to eq(7) }
    specify { expect(evaluator.evaluate(attribute: 'delta')).to be_truthy }
    specify { expect(evaluator.evaluate(attribute: 'yotta')).to be_falsey }
    specify { expect(evaluator.evaluate(attribute: 'theta')).to match_array([1,2,3]) }
    specify do
      expect { evaluator.evaluate(attribute: 'beta') }.to(
        raise_error(BooleanDsl::EvaluationFailed, 'Context does not have key beta'))
    end
  end

  context 'negation' do
    specify { expect(evaluator.evaluate(negation: { attribute: 'alpha' })).to eq(false) }
    specify { expect(evaluator.evaluate(negation: { attribute: 'yotta' })).to eq(true) }
  end

  context 'short circuit' do
    specify 'and' do
      expect(context).not_to receive(:delta)
      evaluator.evaluate(
        left: {
          attribute: 'yotta'
        },
        boolean_operator: 'and',
        right: {
          attribute: 'delta'
        }
      )
    end

    specify 'or' do
      expect(context).not_to receive(:yotta)
      evaluator.evaluate(
        left: {
          attribute: 'delta'
        },
        boolean_operator: 'or',
        right: {
          attribute: 'yotta'
        }
      )
    end
  end
end
