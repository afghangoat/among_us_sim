#!/usr/bin/ruby -w

#Example input: 6|2
$round_limit=900

$num_of_players=0
$num_of_impostors=0
$invalid_entry=false

BEGIN {
  print "This is a simulation of a round of Among Us.\nPlease specify the amount of players and impostors in the standard input in\na format like this: <num_of_players>|<num_of_impostors> (max 9)\nIf values were given, the simulation will proceed.\n"

}

class Player
    
  @@player_remaining = 0
    
  def initialize(name,is_imp=false)
    
    @p_name = name
    @is_imp = is_imp
    @is_alive = true
    @@player_remaining+=1
  end
    
  def display_details()
    puts "---\n#@p_name"
    
    if @is_imp==true
      puts "Role: Impostor"
    else
      puts "Role: Crewmate"
    end
    
    if @is_alive==true
      puts "Alive"
    else
      puts "Dead"
    end
    
    puts "---"
  end
  
  def getout()
    @is_alive=false
    
    $num_of_players-=1
    if @is_imp==true
      $num_of_impostors-=1
    end
    
  end

end
  
  # Create Objects
  #player_array = [  Customer.new("1", "John", "Wisdom Apartments, Ludhiya"), Customer.new("2", "Poul", "New Empire road, Khandala")]
  #player_array.each do |i|
  #  i.display_details()
  #end

$input=gets

$num_of_players=$input[0].ord-48
  
$num_of_impostors=$input[2].ord-48
  
begin  
  if ($num_of_players-2)<$num_of_impostors
      
    print "\nNumber of impostors must not exceed ",($num_of_players-2),"!\n(but given ",$num_of_impostors,")!\n" 
    raise 'Invalid player/impostor ratio.'  
      
  end
    
rescue Exception => e
    
  puts e.message  
  puts e.backtrace.inspect  
  $invalid_entry=true
    
end

$current_round = 0
  
$R=Random.new
  
$FIRST_NAMES=["Jonas","John","Bob","Alice","Samir","James","Omar","Ruby","Arnold","Steve","Bud","Spencer"]
$F_LEN=$FIRST_NAMES.length()

$LAST_NAMES=["Gold","Hill","Duran","Narud","Hill","Seed","The impostor","Msc.","Bsc.","Phd.","Spencer"]
$L_LEN=$LAST_NAMES.length()

def generate_random_name()
  strname=$FIRST_NAMES[$R.rand($F_LEN)]+" "+$LAST_NAMES[$R.rand($L_LEN)]
  
  return strname
end

$player_hash = {}
$COLORS=["red","green","blue","cyan","black","orange","yellow","teal","brown","white"]
def create_players()
  added_impostors=0
  (0..$num_of_players).each do |n|
    is_img_n=false
    
    if $num_of_impostors>added_impostors #Since the order does not really matter here, we can get away with adding the impostors first!
      is_img_n=true
      added_impostors+=1
    end
    
    $player_hash[$COLORS[n]] = Player.new(generate_random_name(),is_img_n)
  end
end

def simulate_meeting()
    
  print "Simulating board meeting... Displaying data:\n"
  vote_choice=0
  
  if $num_of_players > 0
    vote_choice = $R.rand($num_of_players+1) #+1 for chance for tie
  else
    puts "Error: $num_of_players must be greater than 0"
    $current_round=$round_limit+1 #exit simulation immediately
  end
    
  if vote_choice==$num_of_players
    print("Nobody got voted out.")
  end
    
  $iter=0
  $needs_kill=true
  $player_hash.each do |key, player|
    if $iter==vote_choice and $needs_kill==true
        
      $needs_kill=false
      player.getout()
      print "\nPlayer ",key," got voted out!\n"
      
      if $num_of_impostors==0
        print "\nThe crewmates won!\n"
        $current_round=$round_limit+1
        return
      elsif $num_of_players<=2
        print "\nThe impostors won!\n"
        $current_round=$round_limit+1
        return
      end
      
    end
    
    print key, ":"
    player.display_details()
    $iter+=1
  end
    
  print "\nProceeding to next round...\n"
  $current_round+=1
    
end

#main
if $invalid_entry == false
  
  create_players()
  
  while $current_round < $round_limit do
    simulate_meeting()
    $current_round+=1
  end

end

END {
  
  puts "\nSimulation ended. Terminating program...\n"
  
}
