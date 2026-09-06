# frozen_string_literal: true

require "nanacl/geometry"

RSpec.describe "Nanacl geometry" do
  describe Nanacl::Point do
    it "有理数を保ったままスカラー除算する" do
      expect(described_class.new(1, 2) / 3).to eq(described_class.new(Rational(1, 3), Rational(2, 3)))
      expect([described_class.new(1, 2), described_class.new(Rational(1), Rational(2))].uniq.size).to eq(1)
    end

    it "内積・外積・3点の向きを求める" do
      origin = described_class.new(0, 0)
      p1 = described_class.new(2, 0)
      p2 = described_class.new(1, 3)

      expect(p1.dot(p2)).to eq(2)
      expect(p1.cross(p2)).to eq(6)
      expect(origin.orientation(p1, p2)).to eq(1)
      expect(origin.orientation(p2, p1)).to eq(-1)
      expect(origin.orientation(p1, described_class.new(4, 0))).to eq(0)
    end
  end

  describe Nanacl::LimitedLine do
    it "線分同士の交点を有理数で正確に求める" do
      segment1 = described_class.from_points(Nanacl::Point.new(0, 0), Nanacl::Point.new(3, 1))
      segment2 = described_class.from_points(Nanacl::Point.new(0, 1), Nanacl::Point.new(2, 0))

      expect(segment1).to be_intersect_with(segment2)
      expect(segment1.intersection_with(segment2)).to eq(
        Nanacl::Point.new(Rational(6, 5), Rational(2, 5)),
      )
    end

    it "端点で接する線分と交差しない線分を判定する" do
      segment = described_class.new(Nanacl::Point.new(0, 0), Nanacl::Point.new(2, 0))
      touching = described_class.new(Nanacl::Point.new(2, 0), Nanacl::Point.new(3, 1))
      separated = described_class.new(Nanacl::Point.new(3, 0), Nanacl::Point.new(4, 0))

      expect(segment.intersection_with(touching)).to eq(Nanacl::Point.new(2, 0))
      expect(segment).not_to be_intersect_with(separated)
      expect(segment.intersection_with(separated)).to be_nil
    end

    it "重なる区間を線分として返す" do
      segment1 = described_class.new(Nanacl::Point.new(0, 0), Nanacl::Point.new(4, 0))
      segment2 = described_class.new(Nanacl::Point.new(3, 0), Nanacl::Point.new(1, 0))

      expect(segment1.intersection_with(segment2)).to eq(
        described_class.new(Nanacl::Point.new(1, 0), Nanacl::Point.new(3, 0)),
      )
    end

    it "点に縮退した線分を扱う" do
      point = Nanacl::Point.new(1, 0)
      point_segment = described_class.new(point, point)
      segment = described_class.new(Nanacl::Point.new(0, 0), Nanacl::Point.new(2, 0))

      expect(point_segment.intersection_with(segment)).to eq(point)
      expect(point_segment.projection_of(Nanacl::Point.new(3, 4))).to eq(point)
    end

    it "直線との交点または重なりを求める" do
      segment = described_class.new(Nanacl::Point.new(0, 0), Nanacl::Point.new(2, 0))

      expect(segment.intersection_with(Nanacl::Line.new(1, 0, -1))).to eq(Nanacl::Point.new(1, 0))
      expect(segment.intersection_with(Nanacl::Line.new(0, 1, 0))).to eq(segment)
      expect(segment.intersection_with(Nanacl::Line.new(1, 0, -3))).to be_nil
    end

    it "線分上への射影と距離を求める" do
      segment = described_class.new(Nanacl::Point.new(0, 0), Nanacl::Point.new(2, 0))

      expect(segment.projection_of(Nanacl::Point.new(1, 1))).to eq(Nanacl::Point.new(1, 0))
      expect(segment.projection_of(Nanacl::Point.new(3, 1))).to eq(Nanacl::Point.new(2, 0))
      expect(segment.squared_distance_to_point(Nanacl::Point.new(3, 1))).to eq(2)
    end
  end

  describe Nanacl::Line do
    it "係数が定数倍された直線を同一と判定する" do
      line = described_class.new(1, 2, 3)

      expect(line).to eq(described_class.new(-2, -4, -6))
      expect(line).not_to eq(described_class.new(1, 2, 4))
      expect([line, described_class.new(Rational(2), Rational(4), Rational(6))].uniq.size).to eq(1)
    end

    it "不正な係数や同じ2点から直線を作成できない" do
      expect { described_class.new(0, 0, 1) }.to raise_error(ArgumentError)
      expect do
        described_class.from_points(Nanacl::Point.new(1, 1), Nanacl::Point.new(1, 1))
      end.to raise_error(ArgumentError)
    end

    it "指定した座標に対応する座標を有理数で求める" do
      line = described_class.new(2, 3, -1)

      expect(line.x_at_y(0)).to eq(Rational(1, 2))
      expect(line.y_at_x(0)).to eq(Rational(1, 3))
      expect(described_class.new(0, 1, -2).x_at_y(2)).to be_nil
      expect(described_class.new(1, 0, -2).y_at_x(2)).to be_nil
    end

    it "交点を有理数で正確に求める" do
      line1 = described_class.from_points(Nanacl::Point.new(0, 0), Nanacl::Point.new(3, 1))
      line2 = described_class.from_points(Nanacl::Point.new(0, 1), Nanacl::Point.new(2, 0))

      expect(line1.intersection_with(line2)).to eq(
        Nanacl::Point.new(Rational(6, 5), Rational(2, 5)),
      )
      expect(line1.intersection_with(described_class.new(1, -3, 1))).to be_nil
    end

    it "平行・垂直・点の位置を判定する" do
      line = described_class.new(1, -1, 0)

      expect(line).to be_parallel_to(described_class.new(2, -2, 3))
      expect(line).to be_perpendicular_to(described_class.new(1, 1, 0))
      expect(line).to include(Nanacl::Point.new(3, 3))
      expect(line.side(Nanacl::Point.new(3, 2))).to eq(1)
      expect(line.side(Nanacl::Point.new(2, 3))).to eq(-1)
    end

    it "垂線の足と線対称な点を有理数で求める" do
      line = described_class.new(1, 1, -1)
      point = Nanacl::Point.new(0, 0)

      expect(line.projection_of(point)).to eq(Nanacl::Point.new(Rational(1, 2), Rational(1, 2)))
      expect(line.reflection_of(point)).to eq(Nanacl::Point.new(1, 1))
    end
  end

  describe Nanacl::Vector do
    it "有理数を保ったまま演算と判定をする" do
      vector = described_class.new(1, 2)

      expect(vector / 2).to eq(described_class.new(Rational(1, 2), 1))
      expect(vector).to be_parallel_to(described_class.new(-2, -4))
      expect(vector).to be_perpendicular_to(described_class.new(2, -1))
      expect(vector.rotate_90_degrees).to eq(described_class.new(-2, 1))
    end
  end
end
