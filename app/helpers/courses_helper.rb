module CoursesHelper

  #Retorna true si el usuario es CEO dentro del curso
  def is_ceo?(user_id, course_id)
    course_user = CourseUser.where(user_id: user_id, rol:"CEO", course_id:course_id)
    course_user.any?
  end

  #Retorna true si el usuario es Miembro dentro del curso
  def is_member?(user_id, course_id)
    course_user = CourseUser.where(user_id: user_id, course_id:course_id)
    course_user.any?
  end
end
