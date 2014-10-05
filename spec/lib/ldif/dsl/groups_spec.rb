module LDIF
  module DSL
    describe Group do
      let(:builder) { Group::Builder.new }
      let(:group) { builder.build }
      let(:name) { 'Name' }
      let(:email) { 'email@example.com' }
      let(:result_string_without_members) do
        <<-TEXT
dn: cn=#{name},ou=groups,dc=test
objectClass: top
objectClass: groupOfUniqueNames
cn: #{name}
ou: groups

        TEXT
      end

      let(:result_string_with_one_member) do
        <<-TEXT
dn: cn=#{name},ou=groups,dc=test
objectClass: top
objectClass: groupOfUniqueNames
cn: #{name}
ou: groups
uniqueMember: cn=#{email},ou=people,dc=test
        TEXT
      end

      subject { group }

      context 'Initialize' do
        let(:g) { Group.new(name, [email]) }
        subject { g }
        its(:name) { should eq name }
        its(:members) { should match_array([email]) }
      end

      context 'name = #{name}' do
        before { builder.name name }
        its(:name) { should == name }
      end

      context 'group without members' do
        its(:members) { should be_empty }
      end

      context 'group with one member' do
        before { builder.member(email) }
        its(:members) { should == [email] }
      end

        context 'to_s with one member' do
          before { builder.name(name) }
          its(:to_s) { should == result_string_without_members }
        end

      context 'to_s with one member' do
        before do
          builder.name(name)
          builder.member(email)
        end
        its(:to_s) { should == result_string_with_one_member }
      end

      context 'build' do
        before do
          builder.name name
          builder.member email
        end
        it { expect(group).to eq Group.new(name, [email]) }
      end
    end
  end
end