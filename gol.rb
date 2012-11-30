# --------------------------------------- #
# Game Of Life                            #
# nico@nabholz.org                        #
# Thanks to acme, maybe, bluequilla       #
# --------------------------------------- #

# TODO:
#
# Population # and graph; statistics?
# Break "while" if key pressed
# Debug border population error
# pattern import
# pattern editor


# --------------------------------------- SETTINGS


# World width
width = 80

# World height
height = 25

# Initial population density in %; 20.0 seems to be cool
density = 20.0 / 100

# Seconds between generations
time_step = 0.1

# Keep track of creatures age
class Creature
  def initialize
    @age = 0
    # @expected_life = 10
    # @minumum_age_of_reproduction = 2
  end

  def grow
    @age += 1
  end
  
  def to_i
    return 1
  end

  def to_s
    case @age
    when 0..2
      return "."
    when 3..4
      return ","
    when 5..6
      return "o"
    when 7..8
      return "O"
    else
      return "@"
    end
  end
end

# --------------------------------------- INIT


new_world = Hash.new(0)
old_world = Hash.new(0)

generation = 0
population = 0


# --------------------------------------- FILL WORLD


system("clear")
print "Generation: ", generation, "\n\n"

1.upto(height) { |row|

    1.upto(width) { |col|

        # Decide whether current cell lives in accordance with inital density
        new_world[[col, row]] = ((density + rand) / 2).round == 1 ? Creature.new : 0

        # Output creature or empty space and census
        if new_world[[col, row]].to_i == 1
            print new_world[[col, row]].to_s
            population += 1
        else
            print " "
        end

    }

    print "\n"

}

# --------------------------------------- GO


# Talking about my generation #1
generation += 1

# Let the games begin...
until ( population == 0 ) do

    sleep(time_step)
    print "\e[H"
    print "Generation: ", generation, "\n\n"

    # Store new_world in old_world for counting neighbors
    old_world = new_world

    # Restart census
    population = 0

    1.upto(height) { |row|

        1.upto(width) { |col|

            # Determine number of neighbors
            neighbors = old_world[[col-1, row-1]].to_i +
                        old_world[[col-1, row]].to_i +
                        old_world[[col-1, row+1]].to_i +
                        old_world[[col, row-1]].to_i +
                        old_world[[col, row+1]].to_i +
                        old_world[[col+1, row-1]].to_i +
                        old_world[[col+1, row]].to_i +
                        old_world[[col+1, row+1]].to_i

            # Dead in the old world?
            if old_world[[col, row]].to_i == 0

                # GOL Rule #1: If cell is dead and has 3 neighbors, it's alive now:
                if neighbors == 3
                    new_world[[col, row]] = Creature.new
                end

            # Nope, alive!
            else

                # GOL Rule #2: if cell is alive and has less than 2 neighbors, it dies:
                if neighbors < 2
                    new_world[[col, row]] = 0
                end
                # GOL Rule #2: if cell is alive and has 2 or 3 neighbors, nothing changes

                # GOL Rule #4: if cell is alive and has more than 3 neighbors, it dies:
                if neighbors > 3
                    new_world[[col, row]] = 0
                end

            end

            # Output creature then increase its age or empty space and census
            if new_world[[col, row]].to_i == 1
                print new_world[[col, row]].to_s
                new_world[[col, row]].grow
                population += 1
            else
                print " "
            end

        }

        print "\n"

    }

    print "\n"
    generation += 1

end