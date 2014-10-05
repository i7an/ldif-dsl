require 'digest'

module LDIF
  module DSL
    class Person < Struct.new(:first_name, :second_name, :password)
      def to_s
        <<-TEXT
dn: cn=#{username},ou=people,dc=test
cn: #{username}
sn: #{second_name}
givenName: #{first_name}
mail: #{mail}
userPassword: #{password}
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
TEXT
      end

      class Builder
        def first_name(first_name)
          @first_name = first_name
          self
        end

        def second_name(second_name)
          @second_name = second_name
          self
        end

        def password(plain_password)
          @password = "{SHA}#{Digest::SHA1.base64digest(plain_password)}"
          self
        end

        def build
          Person.new(@first_name, @second_name, @password)
        end
      end

    private
      def username
        @username ||= [first_name, second_name].join('_')
      end

      def mail
        @mail ||= "#{username}@example.com"
      end
    end
  end
end