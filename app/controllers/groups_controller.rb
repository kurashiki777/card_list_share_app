class GroupsController < ApplicationController
  before_action :require_login
  before_action :ensure_correct_user, only: [:edit, :update]
  helper ActionView::Helpers::AssetTagHelper
  def index
    @q = Group.ransack(params[:q])
    @groups = @q.result(distinct: true).includes(group_users: :user).order(created_at: :desc).page(params[:page])
  end

  def show
    #@book = Book.new
    @group = Group.find(params[:id])
  end

  def join
    invitation_code = params[:invitation_code]
    @group = Group.find_by_invitation_code(invitation_code)

    if @group
      @group.users << current_user
      redirect_to groups_path, notice: 'グループに参加しました。'
    else
      redirect_to groups_path, alert: '招待コードが無効です。'
    end
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      redirect_to groups_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render "edit"
    end
  end

  def destroy
    @group = Group.find(params[:id])
   #current_userは、@group.usersから消されるという記述。
    @group.users.delete(current_user)
    redirect_to groups_path
  end

  def delete_group
    @group = Group.find(params[:group_id])

    # グループのオーナーだけがグループを削除できるように確認
    if @group.owner_id == current_user.id
      @group.destroy
      redirect_to groups_path, notice: 'グループが削除されました。'
    else
      redirect_to groups_path, alert: 'グループを削除する権限がありません。'
    end
  end

  def show_by_invitation
    @group = Group.find_by(invitation_code: params[:invitation_code])
    if @group
      redirect_to group_path(@group)
    else
      redirect_to groups_path, alert: '招待コードが無効です'
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
end
