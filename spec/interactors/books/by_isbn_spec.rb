describe Books::ByIsbn do
  describe '#call' do
    subject(:generate_create) do
      described_class.call(isbn: isbn)
    end

    let(:isbn) { '9780062379288' }
    let(:interactor_response) { double }

    before do
      allow(interactor_response).to receive(:success?).and_return(true)
      allow(Books::BookData).to receive(:call!).and_return(interactor_response)
      allow(Books::TransformBookData).to receive(:call!).and_return(interactor_response)
    end

    it 'organized the right interactors' do
      expect(described_class.organized).to eq(
        [Books::BookData, Books::TransformBookData]
      )
    end

    it 'is a success' do
      expect(generate_create).to be_a_success
    end
  end
end
