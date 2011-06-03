Factory.sequence :username do |n|
	"myroute_user_#{n}"
end
Factory.sequence :email do |n|
	"myroute_user_#{n}@myroutes.com"
end

Factory.define :user do |f|
	f.username{ Factory.next(:username) }
	f.email{ Factory.next(:email) }
	f.password "1111"
	f.password_confirmation "1111"
end

Factory.define :route do |f|
	f.name 'route name'
	f.description 'route description'
	f.gmap_coords '{"marker":[{"lat":"5", "lng":"6"}]}'
	f.user {|user| user.association(:user)}
end
