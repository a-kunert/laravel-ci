<?php

namespace Tests\Feature\Controllers;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class CommentControllerTest extends TestCase
{
    use RefreshDatabase;

    /** @test */
    public function if_no_content_is_given_the_validation_will_fail()
    {
        $user = User::factory()->create();
        $this->actingAs($user)->json('post',route('comment.store'),['content' => ''])->assertJsonValidationErrors('content');
        $this->actingAs($user)->json('post',route('comment.store.queued'),['content' => ''])->assertJsonValidationErrors('content');
    }

    /** @test */
    public function a_comment_is_stored_in_the_db()
    {
        $user = User::factory()->create();
        $this->actingAs($user)->json('post',route('comment.store'),['content' => 'This is a test']);
        $this->assertDatabaseHas('comments',['user_id' => $user->id, 'content' => 'This is a test']);

    }


}
