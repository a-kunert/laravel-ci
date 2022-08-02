<?php

namespace App\Http\Controllers;

use App\Models\Comment;
use Illuminate\Http\Request;

class CommentController extends Controller
{

    public function store(Request $request)
    {
        $data = $request->validate(['content' => 'required']);
        $user = auth()->user();
        $user->comments()->create($data);
        return redirect()->back();
    }

    public function storeViaQueue(Request $request)
    {
        $data = $request->validate(['content' => 'required']);
    }
}
