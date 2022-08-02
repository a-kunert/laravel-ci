<?php

namespace Tests\Feature\Models;

use App\Models\Comment;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class CommentTest extends TestCase
{
    use RefreshDatabase;

    /** @test */
    public function a_comment_has_a_user()
    {
        $comment = Comment::factory()->create();
        $this->assertInstanceOf(User::class,$comment->author);
    }

    /** @test */
    public function a_user_can_have_comments()
    {
        $user = Comment::factory()->create()->author;
        $this->assertCount(1,$user->comments);
        $this->assertInstanceOf(Comment::class,$user->comments->first());

    }


}
