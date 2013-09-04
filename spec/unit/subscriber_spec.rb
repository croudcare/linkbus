#coding: utf-8

require 'spec_helper'

describe Linkedcare::Bus::Subscriber do

  it 'creates a subscriber with key and handler' do
    subscriber = Linkedcare::Bus::Subscriber.new('patients.#', Proc.new {} )
    expect(subscriber.key).to be
    expect(subscriber.handler).to be
  end

  it 'rejects handler that does not respond to call' do
    expect{ Linkedcare::Bus::Subscriber.new('patients.#', Object.new ) }.to raise_error
  end

  context "Generating Queue names" do
    it 'removes accents' do
      subscriber = Linkedcare::Bus::Subscriber.new('patient.éínameç', Proc.new {} )
      expect(subscriber.queue).to eql('patient.name')
    end

    it 'downcase' do
      subscriber = Linkedcare::Bus::Subscriber.new('PATIENT UPPERCASE', Proc.new {} )
      expect(subscriber.queue).to eql('patient uppercase')
    end

    it 'remove spaces' do
      subscriber = Linkedcare::Bus::Subscriber.new('PATIENT UPPERCASE', Proc.new {} )
      expect(subscriber.queue).to eql('patient uppercase')
    end

    it 'remove non ascii character' do
      subscriber = Linkedcare::Bus::Subscriber.new('patient£', Proc.new {} )
      expect(subscriber.queue).to eql('patient')
    end

  end

  context "Use Queue names" do
    it 'removes accents' do
      subscriber = Linkedcare::Bus::Subscriber.new('pattern.#', Proc.new {}, 'queue.nameç' )
      expect(subscriber.queue).to eql('queue.name')
    end

    it 'accepts _' do
      subscriber = Linkedcare::Bus::Subscriber.new('pattern.#', Proc.new {}, 'queue_name' )
      expect(subscriber.queue).to eql('queue_name')
    end

    it 'accepts  space' do
      subscriber = Linkedcare::Bus::Subscriber.new('pattern.#', Proc.new {}, 'queue name' )
      expect(subscriber.queue).to eql('queue name')
    end

  end
end