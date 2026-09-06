# frozen_string_literal: true

module Nanacl
  class Point
    attr_reader :x, :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def +(other)
      Point.new(@x + other.x, @y + other.y)
    end

    def -(other)
      Point.new(@x - other.x, @y - other.y)
    end

    def *(other)
      Point.new(@x * other, @y * other)
    end

    def /(other)
      Point.new(@x.quo(other), @y.quo(other))
    end

    def ==(other)
      other.is_a?(Point) && @x == other.x && @y == other.y
    end

    alias eql? ==

    def hash
      [@x.to_r, @y.to_r].hash
    end

    def to_s
      "(#{@x}, #{@y})"
    end

    def squared_distance_to(other)
      dx = @x - other.x
      dy = @y - other.y
      (dx * dx) + (dy * dy)
    end

    def distance_to(other)
      Math.sqrt(squared_distance_to(other))
    end

    def squared_magnitude
      (@x * @x) + (@y * @y)
    end

    def magnitude
      Math.sqrt(squared_magnitude)
    end

    def dot(other)
      (@x * other.x) + (@y * other.y)
    end

    def cross(other)
      (@x * other.y) - (@y * other.x)
    end

    def orientation(p2, p3)
      (p2 - self).cross(p3 - self) <=> 0
    end
  end

  class LimitedLine
    attr_reader :p1, :p2, :a, :b, :c

    def initialize(p1, p2)
      @p1 = p1
      @p2 = p2
      @a = p2.y - p1.y
      @b = p1.x - p2.x
      @c = -((@a * p1.x) + (@b * p1.y))
    end

    def self.from_points(p1, p2)
      LimitedLine.new(p1, p2)
    end

    def ==(other)
      other.is_a?(LimitedLine) &&
        ((@p1 == other.p1 && @p2 == other.p2) || (@p1 == other.p2 && @p2 == other.p1))
    end

    alias eql? ==

    def hash
      [@p1, @p2].sort_by { |point| [point.x, point.y] }.hash
    end

    def squared_length
      @p1.squared_distance_to(@p2)
    end

    def length
      Math.sqrt(squared_length)
    end

    def include?(point)
      @p1.orientation(@p2, point).zero? && ((point - @p1).dot(point - @p2) <= 0)
    end

    def intersect_with?(other)
      !intersection_with(other).nil?
    end

    def intersection_with(other)
      case other
      when LimitedLine
        intersection_with_limited_line(other)
      when Line
        intersection_with_line(other)
      else
        raise ArgumentError, "other must be a LimitedLine or Line"
      end
    end

    def projection_of(point)
      return @p1 if @p1 == @p2

      direction = @p2 - @p1
      ratio = (point - @p1).dot(direction).quo(squared_length)
      return @p1 if ratio <= 0
      return @p2 if ratio >= 1

      @p1 + (direction * ratio)
    end

    def squared_distance_to_point(point)
      point.squared_distance_to(projection_of(point))
    end

    def distance_to_point(point)
      Math.sqrt(squared_distance_to_point(point))
    end

    def rotate_90_degrees
      LimitedLine.new(Point.new(-@p1.y, @p1.x), Point.new(-@p2.y, @p2.x))
    end

    private

    def intersection_with_limited_line(other)
      common_points = [@p1, @p2, other.p1, other.p2].uniq.select do |point|
        include?(point) && other.include?(point)
      end
      return common_points.first if common_points.one?

      if common_points.size >= 2
        first, last = common_points.minmax_by { |point| [point.x, point.y] }
        return LimitedLine.new(first, last)
      end

      o1 = @p1.orientation(@p2, other.p1)
      o2 = @p1.orientation(@p2, other.p2)
      o3 = other.p1.orientation(other.p2, @p1)
      o4 = other.p1.orientation(other.p2, @p2)
      return nil unless (o1 * o2).negative? && (o3 * o4).negative?

      to_line.intersection_with(Line.new(other.a, other.b, other.c))
    end

    def intersection_with_line(other)
      return other.include?(@p1) ? @p1 : nil if @p1 == @p2

      line = to_line
      return self if line == other

      intersection = line.intersection_with(other)
      return nil if intersection.nil? || !include?(intersection)

      intersection
    end

    def to_line
      Line.new(@a, @b, @c)
    end
  end

  class Line
    attr_reader :a, :b, :c

    def initialize(a, b, c)
      raise ArgumentError, "a and b cannot both be zero" if a.zero? && b.zero?

      @a = a
      @b = b
      @c = c
    end

    def self.from_points(p1, p2)
      a = p2.y - p1.y
      b = p1.x - p2.x
      c = -((a * p1.x) + (b * p1.y))
      Line.new(a, b, c)
    end

    def distance_to_point(point)
      numerator = ((@a * point.x) + (@b * point.y) + @c).abs
      denominator = Math.sqrt((@a**2) + (@b**2))
      numerator / denominator
    end

    def ==(other)
      other.is_a?(Line) &&
        (@a * other.b) == (other.a * @b) &&
        (@a * other.c) == (other.a * @c) &&
        (@b * other.c) == (other.b * @c)
    end

    alias eql? ==

    def hash
      normalized_coefficients.hash
    end

    def include?(point)
      value_at(point).zero?
    end

    def value_at(point)
      (@a * point.x) + (@b * point.y) + @c
    end

    def side(point)
      value_at(point) <=> 0
    end

    def parallel_to?(other)
      ((@a * other.b) - (other.a * @b)).zero?
    end

    def perpendicular_to?(other)
      ((@a * other.a) + (@b * other.b)).zero?
    end

    def x_at_y(y)
      return nil if @a.zero?

      (-(@b * y) - @c).quo(@a)
    end

    def y_at_x(x)
      return nil if @b.zero?

      (-(@a * x) - @c).quo(@b)
    end

    def intersect_with?(other)
      return true if self == other # Lines are coincident, infinite intersections

      denominator = (@a * other.b) - (other.a * @b)
      !denominator.zero?
    end

    def intersection_with(other)
      if self == other
        return nil # Lines are coincident, infinite intersections
      end

      denominator = (@a * other.b) - (other.a * @b)
      return nil if denominator.zero?

      x = ((@b * other.c) - (other.b * @c)).quo(denominator)
      y = ((other.a * @c) - (@a * other.c)).quo(denominator)
      Point.new(x, y)
    end

    def projection_of(point)
      denominator = (@a * @a) + (@b * @b)
      ratio = value_at(point).quo(denominator)
      Point.new(point.x - (@a * ratio), point.y - (@b * ratio))
    end

    def reflection_of(point)
      projection = projection_of(point)
      (projection * 2) - point
    end

    def rotate_90_degrees
      Line.new(-@b, @a, @c)
    end

    private

    def normalized_coefficients
      coefficients = [@a, @b, @c]
      pivot = coefficients.find { |coefficient| !coefficient.zero? }
      coefficients = coefficients.map { |coefficient| coefficient.quo(pivot).to_r }
      coefficients.map!(&:-@) if coefficients.find { |coefficient| !coefficient.zero? }.negative?
      coefficients
    end
  end

  class Vector
    attr_reader :x, :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def +(other)
      Vector.new(@x + other.x, @y + other.y)
    end

    def -(other)
      Vector.new(@x - other.x, @y - other.y)
    end

    def *(other)
      Vector.new(@x * other, @y * other)
    end

    def /(other)
      Vector.new(@x.quo(other), @y.quo(other))
    end

    def ==(other)
      other.is_a?(Vector) && @x == other.x && @y == other.y
    end


    alias eql? ==

    def hash
      [@x.to_r, @y.to_r].hash
    end

    def dot(other)
      (@x * other.x) + (@y * other.y)
    end

    def cross(other)
      (@x * other.y) - (@y * other.x)
    end

    def magnitude
      Math.sqrt(squared_magnitude)
    end

    def squared_magnitude
      (@x * @x) + (@y * @y)
    end

    def normalize
      mag = magnitude
      return Vector.new(0, 0) if mag.zero?

      self / mag
    end

    def parallel_to?(other)
      cross(other).zero?
    end

    def perpendicular_to?(other)
      dot(other).zero?
    end

    def rotate_90_degrees
      Vector.new(-@y, @x)
    end
  end
end
