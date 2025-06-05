# encoding: UTF-8

require 'spec_helper'

describe "show-models" do
  it "should print a list of models" do
    output = mock_pry('show-models', 'exit-all')

    ar_models = <<MODELS
Beer
  id: integer
  name: string
  type: string
  rating: integer
  ibu: integer
  abv: integer
  belongs_to :hacker
Hacker
  id: integer
  social_ability: integer
  has_many :beers
  has_many :pokemons
Pokemon
  id: integer
  name: string
  caught: binary
  species: string
  abilities: string
  belongs_to :hacker
  has_many :beers (through :hacker)
MODELS

    mongoid_models = <<MODELS
Artist
  _id: BSON::ObjectId
  name: String
  embeds_one :beer (validate)
  embeds_many :instruments (validate)
Instrument
  _id: BSON::ObjectId
  name: String
  embedded_in :artist
MODELS

    internal_models = <<MODELS
\e[0GActionMailbox::InboundEmail
  Table doesn't exist
  has_one :raw_email_attachment (class_name :ActiveStorage::Attachment)
  has_one :raw_email_blob (through :raw_email_attachment, class_name :ActiveStorage::Blob)
ActionMailbox::Record
  Table doesn't exist
ActionText::EncryptedRichText
  Table doesn't exist
  belongs_to :record
  has_many :embeds_attachments (class_name :ActiveStorage::Attachment)
  has_many :embeds_blobs (through :embeds_attachments, class_name :ActiveStorage::Blob)
ActionText::Record
  Table doesn't exist
ActionText::RichText
  Table doesn't exist
  belongs_to :record
  has_many :embeds_attachments (class_name :ActiveStorage::Attachment)
  has_many :embeds_blobs (through :embeds_attachments, class_name :ActiveStorage::Blob)
ActiveStorage::Attachment
  Table doesn't exist
  belongs_to :blob (class_name :ActiveStorage::Blob)
  belongs_to :record
ActiveStorage::Blob
  Table doesn't exist
  has_many :attachments
  has_many :variant_records (class_name :ActiveStorage::VariantRecord)
  has_one :preview_image_attachment (class_name :ActiveStorage::Attachment)
  has_one :preview_image_blob (through :preview_image_attachment, class_name :ActiveStorage::Blob)
ActiveStorage::Record
  Table doesn't exist
ActiveStorage::VariantRecord
  Table doesn't exist
  belongs_to :blob
  has_one :image_attachment (class_name :ActiveStorage::Attachment)
  has_one :image_blob (through :image_attachment, class_name :ActiveStorage::Blob)
MODELS

    expected_output = ar_models

    if defined?(Mongoid)
      output.gsub!(/^ *_type: String\n/, '') # mongoid 3.0 and 3.1 differ on this
      output.gsub!(/Moped::BSON/, 'BSON')    # mongoid 3 and 4 differ on this
      expected_output += mongoid_models
    end

    if Rails::VERSION::MAJOR >= 5
      expected_output = internal_models + expected_output
    end

    output.must_equal expected_output
  end

  it "should highlight the given phrase with --grep" do
    begin
      Pry.color = true

      output = mock_pry('show-models --grep rating', 'exit-all')

      output.must_include "Beer"
      output.must_include "\e[7mrating\e[27m"
      output.wont_include "Pokemon"

      if defined?(Mongoid)
        output.wont_include "Artist"
      end
    ensure
      Pry.color = false
    end
  end

  if defined?(Mongoid)
    it "should also filter for mongoid" do
      output = mock_pry('show-models --grep beer', 'exit-all')
      output.must_include 'Artist'
    end
  end
end
