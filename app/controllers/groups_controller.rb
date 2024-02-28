class GroupsController < ApplicationController
  before_action :require_login
  helper ActionView::Helpers::AssetTagHelper

  def index
    @q = current_user.groups.ransack(params[:q])
    @groups = @q.result(distinct: true).includes(group_users: :user).order(created_at: :desc).page(params[:page])
    # binding.pry
  end

  def show
    @group = Group.find(params[:id])
    @cards = Card.joins(user: :groups).where(groups: { id: @group.id }).order(created_at: :desc)
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
    # binding.pry
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      @group.users << current_user
      redirect_to groups_path
    else
      puts @group.errors.full_messages
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
    if @group.users.include?(current_user)
      @group.users.delete(current_user)
      redirect_to groups_path, notice: 'グループから抜けました。'
    else
      redirect_to groups_path, alert: 'グループから抜けることができませんでした。'
    end
  end

  def delete_group
    @group = Group.find(params[:group_id])

    # グループを削除する権限があるかどうかを確認
    if @group.owner_id == current_user.id
      # 関連する group_users レコードを削除
      @group.group_users.destroy_all

      # グループを削除
      @group.destroy

      redirect_to groups_path, notice: 'グループが削除されました。'
    else
      redirect_to groups_path, alert: 'グループを削除する権限がありません。'
    end
  end

  

  def join_or_show_by_invitation
    invitation_code = params[:invitation_code]
    @group = Group.find_by_invitation_code(invitation_code)
  
    if @group
      if @group.users.include?(current_user)
        redirect_to groups_path, notice: 'すでにグループに参加しています。'
      else
        @group.users << current_user
        if params[:action] == 'show'
          redirect_to group_path(@group), notice: 'グループに参加しました。'
        else
          redirect_to groups_path, notice: 'グループに参加しました。'
        end
      end
    else
      redirect_to groups_path, alert: '招待コードが無効です。'
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end
end
