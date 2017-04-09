module TeamsHelper

  def is_leader?(user_id, team_id)
    course_user = CourseUser.where(user_id: user_id, rol:"LEADER", team_id:team_id)
    course_user.any?
  end

  def is_member_team?(user_id, team_id)
    course_user = CourseUser.where(user_id: user_id, team_id:team_id)
    course_user.any?
  end

  def has_team?(user_id, course_id)
    course_user = CourseUser.where(user_id: user_id, course_id:course_id)
    aux_variable = ""
    if course_user.any?
      cu = course_user.first
      if cu.team_id == nil
        aux_variable = "no"
      end
    end
    aux_variable.empty?
  end
end
