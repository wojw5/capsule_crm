module CapsuleCRM
  module Contactable
    extend ActiveSupport::Concern

    included do
      delegate :phones,     to: :contacts, allow_nil: true
      delegate :phones=,    to: :contacts
      delegate :websites,   to: :contacts, allow_nil: true
      delegate :websites=,  to: :contacts
      delegate :emails,     to: :contacts, allow_nil: true
      delegate :emails=,    to: :contacts
      delegate :addresses,  to: :contacts, allow_nil: true
      delegate :addresses=, to: :contacts
    end

    def contacts=(contacts)
      if contacts.is_a?(Hash)
        contacts = CapsuleCRM::Contacts.new(contacts.symbolize_keys)
      end
      @contacts = contacts unless contacts.blank?
    end

    def contacts
      @contacts ||= CapsuleCRM::Contacts.new
    end

    def destroy_phones
      phones.reject! do |phone|
        CapsuleCRM::Connection.delete(build_contact_destroy_path(phone))
      end
    end

    def destroy_websites
      websites.reject! do |website|
        CapsuleCRM::Connection.delete(build_contact_destroy_path(website))
      end
    end

    def destroy_emails
      emails.reject! do |email|
        CapsuleCRM::Connection.delete(build_contact_destroy_path(email))
      end
    end

    def destroy_addresses
      addresses.reject! do |address|
        CapsuleCRM::Connection.delete(build_contact_destroy_path(address))
      end
    end

    def destroy_contacts
      destroy_addresses
      destroy_emails
      destroy_websites
      destroy_phones
    end

    private

    def build_contact_destroy_path(contact)
      "/api/#{queryable_options.singular}/#{id}/contact/#{contact.id}"
    end
  end
end
