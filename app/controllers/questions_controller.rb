class QuestionsController < ApplicationController
  before_action :check_user_course_membership!

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new question_params

    if @question.save
      redirect_to @question, notice: 'Question successfully created.'
    else
      render :new
    end
  end

  private

  def question
    Question.find(params[:id]) || raise_routing_error
  end

  def course
    Course.find_by_uid(params[:course_id]) || raise_routing_error
  end

  def question_params
    params.require(:question).permit(:content)
  end

  def check_user_course_membership!
    return    if     course.is_public?
    forbidden unless course.has_member? current_user
  end
end