module LDIF
  module DSL

    describe Person do
      let(:builder) { Person::Builder.new }
      let(:person) { builder.build }
      let(:first_name) { 'Name' }
      let(:second_name) { 'Second_Name' }
      let(:username) { [first_name, second_name].join('_') }
      let(:password) { 'password' }
      let(:mail) { "#{username}@example.com" }
      subject { person }

      context 'Initialize' do
        let(:p) { Person.new(first_name, second_name, password) }
        subject { p }

        its(:first_name) { should eq first_name }
        its(:second_name) { should eq second_name }
        its(:password) { should eq password }
      end

      context 'first name = #{first_name}' do
        before { builder.first_name first_name }
        its(:first_name) { should == first_name }
      end

      context 'second name = #{second_name}' do
        before { builder.second_name second_name }
        its(:second_name) { should == second_name }
      end

      context 'password = #{password}' do
        before { builder.password password }
        its(:password) { should == "{SHA}#{Digest::SHA1.base64digest(password)}" }
      end

      context 'build' do
        before do
          builder.first_name first_name
          builder.second_name second_name
          builder.password password
        end
        it { expect(person).to eq Person.new(first_name, second_name, "{SHA}#{Digest::SHA1.base64digest(password)}") }
      end

      context 'username = #{username}' do
        before do
          builder.first_name first_name
          builder.second_name second_name
        end
        its(:username) { should == username }
      end

      context 'mail = #{mail}' do
        before do
          builder.first_name first_name
          builder.second_name second_name
        end
        its(:mail) { should == mail }
      end

      context 'to_s' do
        let(:result_string) do
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
        subject { Person.new(first_name, second_name, password) }
        its(:to_s) { should == result_string }
      end
  end
end

end