<script setup>
import BreezeAuthenticatedLayout from '@/Layouts/Authenticated.vue';
import { Head, useForm } from '@inertiajs/inertia-vue3';
import BreezeInput from '@/Components/Input.vue';
import BreezeLabel from '@/Components/Label.vue';
import BreezeButton from '@/Components/Button.vue';
import BreezeValidationErrors from '@/Components/ValidationErrors.vue';

defineProps({
    comments: Array
});

const form = useForm({
    content: ''
})

const submit = () => {
    form.post(route('comment.store'), {
        onFinish: () => {
            form.reset('content')
        }
    });
};

const submitOnQueue = () => {
    form.post(route('comment.store.queued'), {
        onFinish: () => form.reset()
    });
}

const reset = () => {
    form.reset();
}

</script>

<template>
    <Head title="Dashboard"/>

    <BreezeAuthenticatedLayout>
        <template #header>
            <h2 class="font-semibold text-xl text-gray-800 leading-tight">
                Dashboard
            </h2>
        </template>

        <div class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
                <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                    <div class="p-6 bg-white border-b border-gray-200">
                        You're logged in!
                    </div>
                </div>

                <template v-if="comments.length > 0">

                    <h2 class="font-semibold text-lg text-gray-800 leading-tight my-4">
                        Recent Comments
                    </h2>

                    <div v-for="comment in comments" :key="comment.id" class="bg-white shadow-sm rounded my-4">
                        <div>
                            <div class="flex justify-between text-xs border-b border-gray-200 p-2">
                                <span>{{ comment.created_at }}</span>
                                <span>{{ comment.author.name }}</span>
                            </div>
                            <div class="p-2">
                                {{ comment.content }}
                            </div>
                        </div>
                    </div>

                </template>


                <h2 class="font-semibold text-lg text-gray-800 leading-tight my-4">
                    Add Comment
                </h2>


                <div class="mt-4">
                    <BreezeValidationErrors class="mb-4"/>
                    <BreezeLabel for="comment" value="Comment"/>
                    <BreezeInput dusk="content" id="comment" class="mt-1 block w-full p-1" v-model="form.content" required/>
                </div>

                <div class="mt-4 flex justify-between">

                    <BreezeButton type="button"
                                  :class="{ 'opacity-25': form.processing }"
                                  :disabled="form.processing"
                                  @click="reset">
                        Reset
                    </BreezeButton>


                    <div>
                        <BreezeButton type="button"
                                      class="mr-2"
                                      :class="{ 'opacity-25': form.processing }"
                                      :disabled="form.processing"
                                      @click="submitOnQueue">
                            Submit via Queue
                        </BreezeButton>


                        <BreezeButton type="button"
                                      :class="{ 'opacity-25': form.processing }"
                                      :disabled="form.processing"
                                      dusk="submit"
                                      @click="submit">
                            Submit
                        </BreezeButton>
                    </div>

                </div>


            </div>
        </div>


    </BreezeAuthenticatedLayout>
</template>
