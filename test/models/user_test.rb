require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup 
    @user = User.new(
      name: "Example User", 
      email: "user@example.com",
      password: "foobar",
      password_confirmation: "foobar"
      )
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  
  # nameとemailが空文字やnilではないこと確認するテスト
  test "name should be present" do 
    @user.name = "    "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end
  
  # nameとemailの長さ（文字列の）を検証するテスト
  test "name should not be too long" do
    @user.name = "a"*51
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = "a"*244 + "@example.com"
    assert_not @user.valid?
  end
  
  
  # ユーザー登録されたemailアドレスがフォーマットとして有効かどうかを検証するテスト
  
  # 有効なemailのテスト
  test "email validation should accept valid address" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} shouldd be valid"
    end
  end
  
  # 無効なemailのテスト
  test "email validation should reject invalid address" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  
  # 入力されたメアドがユニークであることを確認するテスト
  test "email address should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  # 入力されたメアドの大文字小文字を判別出来るか確認するテスト
  test "email address should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  
  # 以下の二つおテストは、あえて無効になるパスワードを生成してそのエラーを
  # きちんとキャッチしてくれるか検証するテスト
  
  # 入力されたパスワード空文字列だったときに、無効になることを確認するテスト
  test "password should be present (noblank)" do 
    @user.password = @user.password_confirmation = "" * 6
    assert_not @user.valid?
  end
  
  # パスワードの文字数が最低文字数の６文字より少なかったときにそれを
  # きちんとエラーとしてキャッチするか確認するテスト
  test "password should have a minimum length" do 
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  
  # test "the truth" do
  #   assert true
  # end
end
