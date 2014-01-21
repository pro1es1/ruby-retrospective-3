require 'matrix'

class Matrix
  def []=(i, j, x)
    @rows[i][j] = x
  end
end

class Array
    def each_recur(&block)
        each do |elem|
            if elem.is_a? Array
                elem.each_recur &block
            else
                block.call elem
            end
        end
    end
end

module Graphics
  class Canvas
    def initialize(rows, columns = rows)
      @matrix = Matrix.build(rows, columns) { false }
      @width = columns
      @height = rows
    end
    def width
      @width
    end
    def height
      @height
    end
    def pixel_at?(x, y)
      @matrix[y,x]
    end
    def render_as(type)
      type.render(@matrix)
    end
    def draw(figure)
      if figure.class.to_s == "Graphics::Point"
        set_pixel(figure.x, figure.y)
      elsif figure.class.to_s == "Graphics::Line"
        draw_line figure.from, figure.to
      elsif figure.class.to_s == "Graphics::Rectangle"
        draw_rectangle figure
      end
    end
    def draw_line(start_point, end_point)
      x, y, z, t = start_point.x, start_point.y, end_point.x, end_point.y
      steep = (t - y).abs > (z - x).abs
      if steep
        x, y = y, x
        z, t = t, z
      end
      if x > z then deltas(z, t, x, y, steep) else deltas(x, y, z, t,steep) end
    end
    def deltas(x, y, z, t, steep)
      delta_x = z - x
      delta_y = (t - y).abs
      error = delta_x / 2
      y_step = y < t ? 1 : -1
      increment_y = y
      action(x, y, z, t, delta_x, delta_y, error, increment_y, y_step, steep)
    end
    def action(x, y, z, t, delta_x, delta_y, error, increment_y, y_step, steep)
      x.upto(z) do |x|
        steep ? set_pixel(increment_y, x) : set_pixel(x, increment_y)
        error -= delta_y
        if error <= 0
          increment_y += y_step
          error += delta_x
        end
      end
    end
    def draw_rectangle(rectangle)
      draw_line rectangle.top_left, rectangle.bottom_left
      draw_line rectangle.top_left, rectangle.top_right
      draw_line rectangle.top_right, rectangle.bottom_right
      draw_line rectangle.bottom_left, rectangle.bottom_right
    end
    private
    def set_pixel(x, y)
      @matrix[y,x] = true
    end
  end
  class Point
    def initialize(x, y)
      @x = x
      @y = y
    end
    attr_reader :x
    attr_reader :y
    def ==(point)
      if @x == point.x and @y == point.y then true else false end
    end
    def eql?(point)
      if @x == point.x and @y == point.y then true else false end
    end
    def hash
      [@x, @y].hash
    end
  end
  class Line
    def initialize(from, to)
      @from = from
      @to = to
      if from.x > to.x or from.y > to.y then @from, @to = @to, @from end
    end
    attr_reader :from
    attr_reader :to
    def ==(line)
      if @from == line.from and @to == line.to then true else false end
    end
    def eql?(line)
      if @from == line.from and @to == line.to then true else false end
    end
    def hash
      [@from, @to].hash
    end
  end
  class Rectangle
    def initialize(left, right)
      @left = left
      @right = right
      if left.y > right.y
        @left, @right = @right, @left
      elsif left.x > right.x and left.y == right.y
        @left, @right = @right, @left
      end
    end
    attr_reader :left
    attr_reader :right
    def top_left
      if @left.x <= right.x
        @left
      else
        Point.new right.x, left.y
      end
    end
    def bottom_left
      if @left.x >= right.x
        @left
      else
        Point.new right.x, left.y
      end
    end
    def top_right
      if @left.x >= right.x
        @right
      else
        Point.new left.x, right.y
      end
    end
    def bottom_right
      if @left.x <= right.x
        @right
      else
        Point.new left.x, right.y
      end
    end
    def ==(rectangle)
      if self.top_left==rectangle.top_left and self.bottom_right==rectangle.bottom_right
        true
      else
        false
      end
    end
    def eql?(rectangle)
      if self.top_left==rectangle.top_left and self.bottom_right==rectangle.bottom_right
        true
      else
        false
      end
    end
    def hash
      [self.top_left,self.top_right,self.bottom_left,self.bottom_right].hash
    end
  end
  module Renderers
    class Html
      def Html.render(matrix)
        new=matrix.collect{|item|if item==true then item="<b></b>"else item="<i></i>"end}
        "<!DOCTYPE html>
        <html>
        <head>
          <title>Rendered Canvas</title>
          <style type=\"text/css\">
            .canvas {
              font-size: 1px;
              line-height: 1px;
            }
            .canvas * {
              display: inline-block;
              width: 10px;
              height: 10px;
              border-radius: 5px;
            }
            .canvas i {
              background-color: #eee;
            }
            .canvas b {
              background-color: #333;
            }
          </style>
        </head>
        <body>
          <div class=\"canvas\">
            #{new.to_a.map! {|row| row.join('')}.join("<br>\n")}
          </div>
        </body>
        </html>"
      end
    end
    class Ascii
      def Ascii.render(matrix)
        parsed_matrix=matrix.collect{|item|if item==true then item="@" else item="-" end}
        parsed_matrix.to_a.map {|row| row.join('')}
      end
    end
  end
end