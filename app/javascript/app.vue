<template>
  <draggable v-model='lists' :options="{group: 'lists'}" class='board dragArea' @end='listMoved'>
      <list  v-for='(list, index) in lists' :list='list'></list>
      <div class='list'>
        <a v-if='!editing' v-on:click='startEditing'>Add a list</a>
        <textarea v-if='editing' ref='message' v-model='message' class='form-control mb-1'></textarea>
        <button v-if='editing' v-on:click='submitMessage' class='btn btn-secondary'>Add</button>
        <a v-if='editing' v-on:click='editing=false'>Cancel</a>
      </div>
  </draggable>
</template>

<script>
import draggable from 'vuedraggable'
import list from 'components/list'

export default {
  components: { draggable, list },
  props: ['original_lists'],
  data: function() {
    return {
      lists: this.original_lists,
      editing: false,
      message: ''
    }
  },
  methods: {
    listMoved: function(event) {
      var data = new FormData
      data.append('list[position]', event.newIndex + 1)

      Rails.ajax({
        url: `/lists/${this.lists[event.newIndex].id}/move`,
        type: 'PATCH',
        data: data,
        dataType: 'json',
      })
    },
    startEditing: function() {
      this.editing = true
      this.$nextTick(() => this.$refs.message.focus())
    },
    submitMessage: function() {
      var data = new FormData
      data.append('list[name]', this.message)

      Rails.ajax({
        url: '/lists',
        type: 'POST',
        data: data,
        dataType: 'json',
        success: (data) => {
          const index = window.store.lists.push(data)
          this.message = ''
          this.editing = false
        }
      })
    },
  }
}
</script>

<style scoped>
.dragArea {
  min-height: 20px;
}
.board {
  white-space: nowrap;
  overflow-x: auto;
}
.list {
  background: #e2e4e6;
  border-radius: 3px;
  padding: 15px;
  display: inline-block;
  width: 270px;
  vertical-align: top;
  margin-right: 20px;
}
</style>
