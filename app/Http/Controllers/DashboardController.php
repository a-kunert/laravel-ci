<?php

namespace App\Http\Controllers;

use App\Models\Comment;
use Illuminate\Http\Request;
use Inertia\Inertia;

class DashboardController extends Controller
{
    public function index()
    {
        $comments = Comment::with('author')->get();
        return Inertia::render('Dashboard', ['comments' => $comments]);
    }

}
