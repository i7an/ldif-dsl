require 'spec_helper'

module LDIF
  module DSL
    describe ContentBuilder do
      let(:content_builder) { ContentBuilder.new }
      let(:email) { 'John_Doe' }
      let(:group_name) { 'administrators'}
      let(:first_name) { 'John' }
      let(:second_name) { 'Doe' }
      let(:password) { '123qwe' }

      let(:result_string) do
        <<-TEXT
version: 1

dn: ou=people,dc=test
ou: people
objectClass: top
objectClass: organizationalUnit

dn: ou=groups,dc=test
ou: groups
objectClass: top
objectClass: organizationalUnit

dn: cn=administrators,ou=groups,dc=test
objectClass: top
objectClass: groupOfUniqueNames
cn: administrators
ou: groups
uniqueMember: cn=John_Doe,ou=people,dc=test

dn: cn=John_Doe,ou=people,dc=test
cn: John_Doe
sn: Doe
givenName: John
mail: John_Doe@example.com
userPassword: {SHA}Bf50YcYHwzIpdy1AJQVgEBan0Oo=
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
        TEXT
        end

      subject { content_builder }

      context 'Set people' do
        before do
          content_builder.person do
            first_name 'John'
            second_name 'Doe'
            password '123qwe'
          end
        end
        its(:people) { should == [Person.new(first_name, second_name, "{SHA}#{Digest::SHA1.base64digest(password)}")] }
      end

      context 'Set group' do
        before do
          content_builder.group do
            name group_name
            member "#{first_name}_#{second_name}"
          end
        end
        its(:groups) { should == [Group.new(group_name, [email])] }
      end

      context 'build' do
        before do
          content_builder.person do
            first_name 'John'
            second_name 'Doe'
            password '123qwe'
          end

          content_builder.group do
            name group_name
            member "#{first_name}_#{second_name}"
          end

        end
        its(:build) { should == result_string }
      end


    end
  end
end