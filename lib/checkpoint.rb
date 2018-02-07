require 'httparty'
require 'json'

module Checkpoint
  include HTTParty

  def create_submission(assignment_branch, assignment_commit_link, checkpoint_id, comment, enrollment_id)
    response = self.class.post(
      '/checkpoint_submissions',
      headers: { 'authorization' => @auth_token },
      body: {
        assignment_branch: assignment_branch,
        assignment_commit_link: assignment_commit_link,
        checkpoint_id: checkpoint_id,
        comment: comment,
        enrollment_id: enrollment_id
      }
    )
  end
end
