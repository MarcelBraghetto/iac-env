# frozen_string_literal: true

control "verify_remote_state_s3_bucket" do
    describe aws_s3_bucket(bucket_name: 'iac-env-state-kitchen-terraform-default-terraform') do
        it { should exist }
        it { should_not be_public }
    end
end
