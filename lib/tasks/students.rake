# -*- encoding : utf-8 -*-
namespace :db do

  desc "Заполнение Студентов"
  task(:student => :environment) do  
  name=["Юдин", "Костенчук", "Панасюк", "Чевелёв", "Абазов", "Баева", "Балякин", "Вернер","Галдина"]
  second_name=["Алексей", "Михаил", "Сергей", "Андрей", "Аслан", "Яна", "Михаил", "Ирина", "Ирина"]
  last_name=["Алексндрович", "Ильич", "Сергеевич", "Андреевич", "Эдуардович", "Робертовна", "Александровна", "Александровна"]
  login=["qaa12", "kmi9", "psa31", "has9", "aae4", "byr1", "bma13", "via13", "gia3"]
  email="@mail.msiu.ru"
  password="123123"
  group="6361"
  for i in 0...name.size
    Student.create("group"=>group, "name"=>name[i], "second_name"=>second_name[i], "password_confirmation"=>"123123", "last_name"=>last_name[i], "password"=>"123123", "login"=>login[i], "email"=>login[i]+email)
  end
end 
end 