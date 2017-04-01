module TeamsHelper

  def is_member_to_team?(user_id, team_id)
    course_user = CourseUser.where(user_id: user_id, rol:"MEMBER", team_id:team_id)
    course_user.any?
  end
end
