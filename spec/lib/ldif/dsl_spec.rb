describe '.ldif' do
    let(:for_empty_block) do
      <<-TEXT
version: 1

dn: ou=people,dc=test\nou: people
objectClass: top
objectClass: organizationalUnit

dn: ou=groups,dc=test
ou: groups
objectClass: top
objectClass: organizationalUnit


      TEXT
    end

    let(:for_no_empty_block) do
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
cn: John_Doe\nsn: Doe
givenName: John
mail: John_Doe@example.com
userPassword: {SHA}Bf50YcYHwzIpdy1AJQVgEBan0Oo=
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
      TEXT
    end

    let(:block) do
      proc do
        person do
          first_name 'John'
          second_name 'Doe'
          password '123qwe'
        end

        group do
          name 'administrators'
          member 'John_Doe'
        end
      end
    end

  context 'empty block' do
    it { expect(LDIF::DSL.ldif {}).to eq for_empty_block}
  end

  context 'with block' do
    it { expect(LDIF::DSL.ldif(&block)).to eq for_no_empty_block}
  end

end
