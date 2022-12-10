require 'spec_helper'

describe 'BooleanDsl::Evaluator#evaluate' do
  let(:evaluator) { BooleanDsl::Evaluator.new(nil, nil) }

  specify { expect(evaluator.evaluate(integer: '57')).to eq(57) }
  specify { expect(evaluator.evaluate(decimal: '12.34')).to eq(12.34) }
  specify { expect(evaluator.evaluate(percentage: '89%')).to eq(0.89) }
  specify { expect(evaluator.evaluate(string: 'alpha5')).to eq('alpha5') }

  describe 'evaluate array' do
    subject { evaluator.evaluate(tree) }

    let(:tree) { { array: array } }

    context 'where array is empty' do
      let(:array) { [] }
      specify { expect(subject).to eq([]) }
    end

    context 'where array is single element' do
      let(:array) { [{ integer: "1" }] }
      specify { expect(subject).to match_array([1]) }
    end

    context 'where array is multiple elements (of different types)' do
      let(:array) { [{ integer: "1" }, { string: "2" }, { decimal: "0.34" }] }
      specify { expect(subject).to match_array([1,'2',0.34]) }
    end
  end

  specify do
    expect(evaluator.evaluate(
      left: { integer: '+1' },
      comparison_operator: '==',
      right: { integer: '1' },
    )).to be_truthy
  end

  specify do
    expect(evaluator.evaluate(
      left: { percentage: '-14.5%' },
      comparison_operator: '<',
      right: { percentage: '+5%' },
    )).to be_truthy
  end

  specify do
    expect(evaluator.evaluate(
      left: { decimal: '-2.1' },
      comparison_operator: '<',
      right: { decimal: '+1.2' },
    )).to be_truthy
  end

  specify do
    expect(evaluator.evaluate(
      left: { integer: '1' },
      comparison_operator: '<',
      right: { integer: '1' },
    )).to be_falsey
  end

  specify do
    expect(evaluator.evaluate(
      left: { array: [{ integer: '1' }, { integer: '2' }] },
      comparison_operator: 'includes',
      right: { integer: '2' },
    )).to be_truthy
  end

  specify do
    expect(evaluator.evaluate(
      left: { array: [{ integer: '1' }, { integer: '2' }] },
      comparison_operator: 'excludes',
      right: { integer: '2' },
    )).to be_falsey
  end

  specify do
    expect(evaluator.evaluate(
      left: {
        left: { integer: '1' },
        comparison_operator: '==',
        right: { integer: '1' },
      },
      boolean_operator: 'and',
      right: {
        left: { integer: '1' },
        comparison_operator: '==',
        right: { integer: '1' },
      }
    )).to be_truthy
  end

  specify do
    expect(evaluator.evaluate(
      left: {
        left: { integer: '1' },
        comparison_operator: '==',
        right: { integer: '-1' },
      },
      boolean_operator: 'and',
      right: {
        left: { integer: '1' },
        comparison_operator: '==',
        right: { integer: '1' },
      }
    )).to be_falsey
  end

  specify do
    expect(evaluator.evaluate(
      left: {
        left: { integer: '1' },
        comparison_operator: '==',
        right: { integer: '9' },
      },
      boolean_operator: 'or',
      right: {
        left: { integer: '1' },
        comparison_operator: '==',
        right: { integer: '1' },
      }
    )).to be_truthy
  end

  specify do
    expect(evaluator.evaluate(
      left: {
        left: { integer: '1' },
        comparison_operator: '==',
        right: { integer: '9' },
      },
      boolean_operator: 'or',
      right: {
        left: { integer: '7' },
        comparison_operator: '==',
        right: { integer: '2' },
      }
    )).to be_falsey
  end

  specify do
    expect(evaluator.evaluate(
      expression: {
        left: { integer: '1' },
        comparison_operator: '!=',
        right: { integer: '1' }
      }
    )).to be_falsey
  end
end
