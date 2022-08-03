<?php

namespace App\Http\Controllers;

use App\Jobs\StoreComment;
use App\Models\Comment;
use Illuminate\Http\Request;

class CommentController extends Controller
{

    public function store(Request $request)
    {
        StoreComment::dispatchSync(auth()->user(), $request->validate(['content' => 'required']));
        return redirect()->back();
    }

    public function storeViaQueue(Request $request)
    {
        StoreComment::dispatch(auth()->user(), $request->validate(['content' => 'required']));
        return redirect()->back();
    }
}
