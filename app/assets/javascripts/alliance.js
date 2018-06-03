////////////////////////////////////////////////
//// Setting up a general ajax method to handle
//// transfer of data between client and server
////////////////////////////////////////////////
function run_ajax(method, data, link, callback=function(res){organizations.get_organizations()}){
  $.ajax({
    method: method,
    data: data,
    url: link,
    success: function(res) {
      // if (method === "DELETE"){
      // location.reload();};
      callback(res);
    },
    error: function(res) {
      console.log("error");
    }
  })
}

///////////////////////////////////////////////////////
//// A component to create a camp alliance list item
///////////////////////////////////////////////////////

Vue.component('organization-row', {

  template: `
    <tr>
      <td>{{organization.name}}</td>
      <td>{{organization.members}}</td>
      <td><a v-on:click="remove_record(organization)" class = "delete">DELETE</a></td>
    </tr>
  `,

  props: {
    organization: Object
  },

  data: function () {
    return {
      allinace_id: 0
    }
  },

  created() {
    this.alliance_id = $('#aid').val();
  },

  methods: {
    go_to: function(organization){
      run_ajax('GET',0,'/alliances/'.concat(organization['id']));
    },
    remove_record: function(organization){
      run_ajax('DELETE',0,'/alliances/'.concat(this.alliance_id,'/organizations/',organization['id']));
      run_ajax('GET', {}, '/alliances/'.concat(this.alliance_id, '/orgs.json'), function(res){organizations.organizations = res});
    }
  }
});




//////////////////////////////////////////
////***  The Vue instance itself  ***////
/////////////////////////////////////////
var organizations = new Vue({

  el: '#alliances',

  data: {
    alliance_id: 0,
    organizations: [],
    modal_open: false,
    errors: {}
  },

  created() {
    this.alliance_id = $('#aid').val();
  },

  methods: {
    switch_modal: function(event){
      this.modal_open = !(this.modal_open);
    },

    get_organizations: function(){
      run_ajax('GET', {}, '/alliances/'.concat(this.alliance_id, '/orgs.json'), function(res){organizations.organizations = res});
    }
  },

  mounted: function(){
    this.get_organizations();
  }
});