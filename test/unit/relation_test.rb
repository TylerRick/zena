require 'test_helper'

# Test Relation. RelationProxy is tested in its own file.
class RelationTest < Zena::Unit::TestCase

  def test_cannot_create
    login(:ant) # not an admin
    relation = Relation.create(:source_role => 'wife', :target_role => 'husband', :source_kpath => 'NRC', :target_kpath => 'NRC', :source_icon => "<img src='/img/user_pink.png'/>", :target_icon => "<img src='/img/user_blue.png'/>")
    assert relation.new_record?
    assert_equal 'You do not have the rights to do this.', relation.errors[:base]
  end

  def test_cannot_update
    login(:ant) # not an admin
    relation = relations(:node_has_tags)
    assert !relation.update_attributes(:target_kpath => 'NP')
    assert_equal 'You do not have the rights to do this.', relation.errors[:base]
  end

  def test_can_create
    login(:lion) # admin
    relation = Relation.create(:source_role => 'wife', :target_role => 'husband', :source_kpath => 'NRC', :target_kpath => 'NRC', :source_icon => "<img src='/img/user_pink.png'/>", :target_icon => "<img src='/img/user_blue.png'/>")
    assert !relation.new_record?
    assert_equal sites_id(:zena), relation[:site_id]
  end

  def test_cannot_set_site_id
    login(:lion) # admin
    relation = Relation.create(:source_role => 'wife', :target_role => 'husband', :source_kpath => 'NRC', :target_kpath => 'NRC', :source_icon => "<img src='/img/user_pink.png'/>", :target_icon => "<img src='/img/user_blue.png'/>", :site_id => sites_id(:ocean))
    assert !relation.new_record?
    assert_equal sites_id(:zena), relation[:site_id]
  end

  def test_set_site_id
    login(:lion) # admin
    relation = relations(:node_has_tags)
    original_site_id = relation.site_id
    relation.update_attributes(:site_id => 1234)
    assert_equal original_site_id, relation.site_id
  end

  def test_can_update
    login(:lion) # admin
    relation = relations(:node_has_tags)
    assert relation.update_attributes(:target_kpath => 'NP')
    assert_equal 'NP', relation.target_kpath
  end
end
