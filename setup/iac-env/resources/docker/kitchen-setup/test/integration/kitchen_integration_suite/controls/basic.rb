# frozen_string_literal: true

control "file_check" do
    describe file('./test/fixtures/terraform_fixture_module/foobar') do
        it { should exist }
    end
end
